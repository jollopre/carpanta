describe('New appointment', () => {
  describe('onSubmit', () => {
    test('datetime is unlocalised', () => {
      document.body.innerHTML = `
        <form data-ref="customer_appointment_new">
          <input name="appointment[starting_at]" type="datetime-local">
          <input type="submit" value="Create">
        </form>
      `;
      require('../../../customers/appointments/new');
      const form = document.querySelector('form');
      const submit = form.querySelector('input[type="submit"]')
      const datetimeLocal = form.querySelector('input[type="datetime-local"]');
      datetimeLocal.value = '2020-06-03T06:02';

      submit.click();

      expect(datetimeLocal.value).toBe('2020-06-03T06:02:00');
    });
  });
});
