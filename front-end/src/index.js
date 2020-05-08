import { safelyGetLocalStorage } from "./js/localStorageWrapper";
import { selectIds } from "./js/constants";
import "./main.scss";

window.addEventListener("DOMContentLoaded", () => {
  const storage = safelyGetLocalStorage();

  if (!storage) {
    return;
  }

  selectIds.forEach((selectId) => {
    const selectInput = document.getElementById(selectId);
    const value = storage.getItem(selectId) || selectInput.options[1].value;
    selectInput.value = value;

    selectInput.addEventListener("change", (event) => {
      console.log("saving...");
      storage.setItem(selectId, event.target.value);
    });
  });
});
