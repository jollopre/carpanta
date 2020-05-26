document.addEventListener('DOMContentLoaded', (event) => {
  timeHTMLCollection = document.getElementsByTagName('time');
  const times = [].slice.call(timeHTMLCollection);
  const locale = navigator.language;
  console.log("locale: %s", locale);
  times.forEach((time) => { time.textContent = new Date(time.textContent).toLocaleString(locale) });
});
