import "rateyo";

document.rateNote = function rateNote(noteId, inputId) {
  if (document.getElementById("notes")) {
    $(noteId).rateYo({ numStars: 5, halfStar: true, starWidth: "50px" });
    if (!document.querySelector("#note")) {
      $(noteId).rateYo(
        "rating",
        parseFloat(document.querySelector(inputId).value) || 0
      );
    }
    $(noteId).rateYo("option", "onSet", function(rating) {
      document.querySelector(inputId).value = rating;
    });
  }
};

document.staticRating = function staticRating(selector, rating) {
  $(selector).rateYo({
    starWidth: "40px",
    readOnly: true
  });
  $(selector).rateYo("rating", rating || 0);
};

document.addEventListener("DOMContentLoaded", e => {
  document.rateNote("#rating-note", "#course_note");
});

if (document.querySelector(".course-note")) {
  document.querySelectorAll(".course-note").forEach(n => {
    document.staticRating(n, parseFloat(n.dataset.note));
  });
}
