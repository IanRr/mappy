<mappy-map>
<a onclick={cycleColors}>click here for silly effect</a>  <div class="map-container">
  <svg onwheel={wheel} ref="svgmap" width="100%" height="100%" style="transform:scale({mapScale});transform-origin:{zoomFocus.x}px {zoomFocus.y}px" xmlns="http://www.w3.org/2000/svg" xmlns:amcharts="http://amcharts.com/ammap" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1">
    <path each={opts.countries} style="fill:{fillColor};opacity:{currentChoice.id?.4:1}" class={selected:currentChoice.id===id} id={id} title={name} d={path} onclick={popup} />
  </svg>
  </div>
  <aside onclick={clearSelection} style="top:{popupPosition.y}px;left:{popupPosition.x}px;" ref="popup" if={currentChoice.id}>
    <h1>{currentChoice.name}</h1>
    <p if={currentChoice.nativeName && currentChoice.nativeName!==currentChoice.name} class="native-name">{currentChoice.nativeName}</p>
    <dl if={currentChoice.capital}>
      <dt>Capital</dt>
      <dd>{currentChoice.capital}</dd>
      <dt>Currencies</dt>
      <dd each={currentChoice.currencies}><span class="currency-symbol">{symbol}</span> {name} ({code})</dd>
      <dt if={currentChoice.regionalBlocs[0]}>Member of:</dt>
      <dd each={currentChoice.regionalBlocs}><b>{acronym}</b> ({name})</dd>
      <img class="flag" src={currentChoice.flag}>
    </dl>
    <img class="loader" if={!currentChoice.capital} src="ajax-loader.gif">
  </aside>


  <script>

    let tag = this;

    tag.currentChoice = {};
    tag.popupPosition = {};
    tag.zoomFocus = {};
    tag.mapScale = 1;









    let landColors = [
'#BE4E46',
'#D75349',
'#CA5147',
'#B04B43',
'#A04740',
'#BE7C46',
'#D78A49',
'#CA8347',
'#B07443',
'#A06B40',
'#2A7272',
'#2C8181',
'#2B7979',
'#286969',
'#266060',
'#359245',
'#38A54B',
'#369B48',
'#338642',
'#317A3E'
      // '#232323',
      // '#343434',
      // '#333333',
      // '#444444',
      // '#555555',
      // '#666666',
      // '#777777',
      // '#888888',
      // '#999999',
      // '#aaaaaa',
      // '#bbbbbb',
      // '#cccccc',
      // '#dddddd',
      // '#cdcdcd'
    ];


    assignColors()  {
      opts.countries.forEach(function(country) {
        country.fillColor = tag.getRandomColor();
      });
    }


    wheel(ev)  {
      let mvmnt = (ev.deltaY * -1) / 1000;
      tag.mapScale = tag.mapScale + mvmnt;
      if (tag.mapScale<1) {
        tag.mapScale = 1;
      }
      console.log(mvmnt);
      if (mvmnt>0)  {
        tag.zoomFocus = {
          x: ev.pageX,
          y: ev.pageY
        };
      }
      tag.update();
    }

    popup(ev) {
      if (tag.currentChoice.id===ev.item.id)  {
        tag.clearSelection();
        return;
      }
      tag.refs.svgmap.appendChild(ev.target);
      tag.currentChoice = ev.item;

      superagent
      .get('https://restcountries.eu/rest/v2/alpha/'+tag.currentChoice.id)
      .query({ fields: 'capital;currencies;nativeName;flag;regionalBlocs' })
      .end((err, res) => {
        if (err)  {
          throw new Error(err);
        }
        for (prop in res.body)  {
          tag.currentChoice[prop] = res.body[prop];
        }
        tag.update();
      });



      let pos = ev.target.getBoundingClientRect();
      tag.popupPosition = {
        x : ev.pageX + 64,
        y : ev.pageY - 64
      };
      tag.update();
    }

    getRandomColor()  {
      return landColors[Math.floor(Math.random()*landColors.length)];
    }

    cycleColors() {
      tag.refs.svgmap.classList.add('silly');
      var cnt = 1;
      var timeout = setInterval(function()  {
        tag.assignColors();
        tag.update();
        cnt++;
        if (cnt>10) {
          tag.refs.svgmap.classList.remove('silly');
          clearInterval(timeout);
        }
      },500);
    }

    clearSelection()  {
      tag.currentChoice = {};
      tag.update();
    }


    tag.assignColors();

  </script>

</mappy-map>
