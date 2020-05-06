/* 
  utilities.js
  KaraokeBrowser

  Created by Wangchou Lu on R 2/05/06.
  Copyright © Reiwa 2 com.wcl. All rights reserved.
*/

// Webkit messageHanders
var console = {
    log: function(msg) {
        window.webkit.messageHandlers.logging.postMessage(msg)
    }
}

window.onerror = (msg, url, line, column, error) => {
  const message = {
    message: msg,
    url: url,
    line: line,
    column: column,
    error: JSON.stringify(error)
  }

  if (window.webkit) {
    window.webkit.messageHandlers.error.postMessage(message);
  } else {
    console.log("Error:", message);
  }
};

function addKaraokeButton() {
    var button = document.createElement("button");
    button.innerHTML = "K";
    button.style.position = "fixed"
    button.style.backgroundColor = "#0C9"
    button.style.bottom = "20px"
    button.style.right = "20px"
    button.style.width = "60px"
    button.style.height = "60px"
    button.style.fontSize = "24px"
    //button.className = "karaokeButton"

    document.body.appendChild(button);
    
    button.onclick = () => {
        console.log("===== on click ====")
        const myVideo = document.querySelector('video');
        let audioCtx = new (window.AudioContext || window.webkitAudioContext);

        const source = audioCtx.createMediaElementSource(myVideo);
        var panner = audioCtx.createPanner();
        panner.panningModel = 'equalpower';
        panner.setPosition(-1, 0, 0);

        source.connect(panner);
        panner.connect(audioCtx.destination);

        myVideo.play()
    };
}
