import createChannel from "./setup";
const main = document.getElementById("navbar-subscriber");
const available_langs = ["fr", "ar"];
const lang = available_langs.includes(window.location.pathname.substr(1, 2))
  ? window.location.pathname.substr(1, 2)
  : "ar";

if (main) {
  const not_count = document.getElementById("notification-count");
  const not_content = document.getElementById("notification-content");
  const bell = document.getElementById("bell");

  createChannel(
    { channel: "NewCourseChannel", driver: main.dataset.driver, lang: lang },
    {
      received({ notification_count, notification_content }) {
        not_count.innerHTML = notification_count;
        not_content.innerHTML = notification_content;
        bell.classList.add("animate");
        setTimeout(() => {
          bell.classList.remove("animate");
        }, 5000);
      }
    }
  );
}
