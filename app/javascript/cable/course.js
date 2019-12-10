import createChannel from "./setup";
const main = document.getElementById("course-status");
const available_langs = ["fr", "ar"];
const lang = available_langs.includes(window.location.pathname.substr(1, 2))
  ? window.location.pathname.substr(1, 2)
  : "ar";

if (main) {
  createChannel(
    { channel: "CourseChannel", id: main.dataset.id, lang: lang },
    {
      received({ driver_status, client_status }) {
        if (main.dataset.user === "driver") {
          main.innerHTML = driver_status;
        } else if (main.dataset.user === "client") {
          main.innerHTML = client_status;
          if (document.getElementById("authenticity_token")) {
            const token = document.getElementsByName("csrf-token")[0].content;
            document.getElementById("authenticity_token").value = token;
            document.rateNote("#rating-note", "#course_note");
          }
          const avg = document.querySelector(".course-note");
          document.staticRating(avg, parseFloat(avg.dataset.note));
        }
      }
    }
  );
}
