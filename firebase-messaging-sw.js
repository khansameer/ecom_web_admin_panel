// web/firebase-messaging-sw.js

importScripts('https://www.gstatic.com/firebasejs/9.22.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.22.2/firebase-messaging-compat.js');

firebase.initializeApp({
   apiKey: "AIzaSyCOdqy5v0vZpfP59275K6RqCaszeKYhz-0",
    authDomain: "neeknots-a8758.firebaseapp.com",
    databaseURL: "https://neeknots-a8758-default-rtdb.firebaseio.com",
    projectId: "neeknots-a8758",
    storageBucket: "neeknots-a8758.firebasestorage.app",
    messagingSenderId: "1027672009884",
    appId: "1:1027672009884:web:caf81d5b167a2bbf3a9159",
    measurementId: "G-M3HZWXWJRL"
});

const messaging = firebase.messaging();
