const terms = document.getElementById("user_terms");

if (terms) {
  terms.addEventListener("click", e => {
    const signup = document.getElementById("signup-btn");
    signup.toggleAttribute("disabled");
  });
}
