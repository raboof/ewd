function toggle(language, visible) {
  const entries = document.body.querySelectorAll('.' + language);
  for (var index = 0; index < entries.length; index++) {
    entries[index].style.display = visible ? 'block' : 'none';
  }
}

function disableLang(lang) {
  document.getElementById(lang).style.display = 'none';
  document.getElementById('no' + lang).style.display = 'inline';
  toggle(lang, false);
}
function enableLang(lang) {
  document.getElementById('no' + lang).style.display = 'none';
  document.getElementById(lang).style.display = 'inline';
  toggle(lang, true);
}
