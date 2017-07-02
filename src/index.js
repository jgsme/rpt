const html = require('yo-yo')

const onClick = event =>
  location.href = `/?id=${document.getElementById('idOrUrl').value}`

const header = html`
  <header>
    <a href="/">RPT</a>
    <span id="jump">
      <input id="idOrUrl" type="text" placeholder="Enter id or URL" />
      <button class="pure-button pure-button-primary" onclick=${onClick}>
        GO
      </button>
    </span>
  </header>
`

document.getElementById('header').appendChild(header)

const main = async () => {
  const idOrUrl = location.search.split('=')[1] || 'spacesushipic'
  const res = await fetch(`https://rpt.now.sh/p?id=${idOrUrl}`)
  const url = await res.text()
  const el = html`
    <div id="wrapper">
      <div class="inputs">
        <p>
          <label for="url">URL</label>
          <input id="url" value="${url}" type="text" size="57" />
        </p>
        <p>
          <label for="md">Markdown</label>
          <input id="md" value="![]${url}" type="text" size="50" />
        </p>
      </div>
      <img src="${url}" />
    </div>
  `
  document.getElementById('main').appendChild(el)
}

main()
