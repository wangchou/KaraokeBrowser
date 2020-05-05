/* 
  utilities.js
  KaraokeBrowser

  Created by Wangchou Lu on R 2/05/06.
  Copyright © Reiwa 2 com.wcl. All rights reserved.
*/

function addKaraokeButton() {
    var button = document.createElement("button");
    button.innerHTML = "K";
    button.style.position = "fixed"
    button.style.bottom = "20px"
    button.style.right = "20px"
    button.className = "karaokeButton"

    document.body.appendChild(button);
    
    button.addEventListener ("click", function() {
        const myVideo = document.querySelector('video');
        let audioCtx = new (window.AudioContext || window.webkitAudioContext);

        const source = audioCtx.createMediaElementSource(myVideo);
        var panner = audioCtx.createPanner();
        panner.panningModel = 'equalpower';
        panner.setPosition(-1, 0, 0);

        source.connect(panner);
        panner.connect(audioCtx.destination);

        myVideo.play()
    });
}
