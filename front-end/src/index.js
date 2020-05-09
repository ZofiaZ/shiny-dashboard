import { safelyGetLocalStorage } from "./js/localStorageWrapper";
import { selectIds } from "./js/constants";
import { handleFirstTab } from "./js/accessibility";
import "./main.scss";

const storage = safelyGetLocalStorage();

window.addEventListener("DOMContentLoaded", () => {
  selectIds.forEach((selectId) => {
    const selectInput = document.getElementById(selectId);

    if (selectInput) {
      const value = storage?.getItem(selectId) || selectInput.options[1].value;
      selectInput.value = value;
      selectInput.options[0].remove();

      if (storage) {
        selectInput.addEventListener("change", (event) => {
          storage.setItem(selectId, event.target.value);
        });
      }
    }
  });
});

window.addEventListener("keydown", handleFirstTab);
