class Home {
  constructor() {
    this.url_regex = new RegExp(/[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)/);
    this.domain = 'shorten.ly';
    this.bindEvent();
  }

  submitForm(form, data, callback) {
    $.ajax({
      url: form.action,
      type: form.method,
      cache: false,
      contentType: false,
      processData: false,
      data: data,
      success: (res) => { callback(res); },
      error: () => {
        alert('system error, sorry for this inconvenient !!!');
      }
    });
  };

  encode(e) {
    e.preventDefault();
    e.stopPropagation();
    let form = $(e)[0].currentTarget,
      data = new FormData(form);
    
    if (!this.url_regex.test(data.get('url'))) {
      $('#encode-result').text('URL invalid.');
      return;
    }  

    this.submitForm(form, data, (res) => {
      if (res.code == 200) {
        $('#encode-result').text(res.data.url);
      } else {
        $('#encode-result').text(res.data.message);
      }
    });
  };

  decode(e) {
    e.preventDefault();
    e.stopPropagation();
    let form = $(e)[0].currentTarget,
      data = new FormData(form);

    if (!this.url_regex.test(data.get('url')) || !data.get('url').includes(this.domain)) {
      $('#decode-result').text('URL invalid.');
      return;
    }  

    this.submitForm(form, data, (res) => {
      if (res.code == 200) {
        $('#decode-result').text(res.data.url);
      } else {
        $('#decode-result').text(res.data.message);
      }
    });
  };

  bindEvent() {
    $('.encode-form')[0].addEventListener('submit', e => { this.encode(e); });
    $('.decode-form')[0].addEventListener('submit', e => { this.decode(e); });
  };
}

jQuery(() => {
  new Home();
})
