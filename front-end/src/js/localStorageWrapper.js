const tryGetLocalStorage = () => {
  try {
    return localStorage;
  } catch {
    return null;
  }
};

export const safelyGetLocalStorage = () => {
  const storage = tryGetLocalStorage();
  if (!storage) {
    console.log("local storage not supported");
  }
  return storage;
};
