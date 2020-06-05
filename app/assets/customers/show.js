const setDateToLocale = () => {
  const timeElements = [...document.getElementsByTagName('time')];
  const locale = navigator.language;

  timeElements.forEach((time) => {
    time.textContent = new Date(time.textContent).toLocaleString(locale)
  });
};

if (document.readyState !== "loading") {
    setDateToLocale();
} else {
    document.addEventListener("DOMContentLoaded", setDateToLocale);
}
