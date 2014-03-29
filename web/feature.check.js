(function () {
  var chromeMatch = window.navigator.appVersion.match(/Chrome\/(\d+)\./);

  if (chromeMatch) {
    var chromeVersion = parseInt(chromeMatch[1], 10);

    console.log('Chrome ' + chromeVersion);

    if (chromeVersion >= 35) {
      window.alert('This site will not work properly until Chrome 35 is promoted to stable. Changes were made to Shadow DOM styling which are not currently present. Please use an earlier version.')
    } else if (chromeVersion >= 32) {
      if (typeof window.HTMLDivElement.prototype['createShadowRoot'] == 'undefined') {
        window.prompt('This site uses experimental web platform features. To view paste the following into another tab. Enable the feature and restart Chrome', 'chrome://flags/#enable-experimental-web-platform-features');
      }
    } else {
      window.alert('This site is only viewable in the latest stable version of Chrome');
    }
  } else {
    window.alert('This site is only viewable in the latest stable version of Chrome');
  }
})();
