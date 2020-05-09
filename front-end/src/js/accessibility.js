const handleMouseDownOnce = () => {
  document.body.classList.remove("userTabbed");

  window.removeEventListener("mousedown", handleMouseDownOnce);
  window.addEventListener("keydown", handleFirstTab); // eslint-disable-line no-use-before-define
};

const getKeyCode = (e) => e.which || e.keyCode;

export const handleFirstTab = (event) => {
  const keyCode = getKeyCode(event);
  const tabKeyCode = 9;

  if (keyCode === tabKeyCode) {
    document.body.classList.add("userTabbed");

    window.removeEventListener("keydown", handleFirstTab);
    window.addEventListener("mousedown", handleMouseDownOnce);
  }
};
