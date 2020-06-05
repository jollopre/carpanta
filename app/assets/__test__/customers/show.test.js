describe('Show customer', () => {
  test('time elements are localised', () => {
    document.body.innerHTML = `
      <div>
        <time datetime="2020-05-26T07:45:12Z">2020-05-26T07:45:12Z</time>
      </div>
    `;
    require('../../customers/show');
    const localisedTime = document.querySelector('time').innerHTML;

    expect(localisedTime).toBe('5/26/2020, 7:45:12 AM');
  });
});
