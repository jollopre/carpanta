const onSubmitHandler = (event) => {
  const form = event.target;
  const datetimeLocal = form.querySelector('input[type="datetime-local"]');

  let iso8601 = null;
  if (datetimeLocal.value) {
    iso8601 = new Date(datetimeLocal.value).toISOString();
    datetimeLocal.value = iso8601.replace(/\.[0-9]{3}Z/, '');
  }
  return true;
};

const addSubmitHandler = () => {
  const form = document.querySelector('form[data-ref="customer_appointment_new"]');
  if (form) {
    form.addEventListener('submit', onSubmitHandler);
  }
};

if (document.readyState !== "loading") {
  addSubmitHandler();
} else {
  document.addEventListener("DOMContentLoaded", addSubmitHandler);
}
