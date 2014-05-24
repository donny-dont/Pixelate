(function () {
  var chromeMatch = window.navigator.appVersion.match(/Chrome\/(\d+)\./);

  if (chromeMatch) {
    var chromeVersion = parseInt(chromeMatch[1], 10);

    console.log('Chrome ' + chromeVersion);

    if (chromeVersion < 35) {
      window.alert('This site is only viewable in the latest stable version of Chrome');
    }
  } else {
    window.alert('This site is only viewable in the latest stable version of Chrome');
  }
})();
