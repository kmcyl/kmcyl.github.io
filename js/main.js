/* Kaitlyn Cheng — portfolio interactions */
(function () {
  'use strict';

  /* ----- nav: scrolled state + scrollspy ----- */
  var nav = document.getElementById('nav');
  var onScroll = function () {
    nav.classList.toggle('scrolled', window.scrollY > 40);
  };
  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll();

  var navLinks = Array.prototype.slice.call(nav.querySelectorAll('nav a'));
  var sections = navLinks
    .map(function (a) { return document.querySelector(a.getAttribute('href')); })
    .filter(Boolean);

  var spy = new IntersectionObserver(function (entries) {
    entries.forEach(function (entry) {
      if (!entry.isIntersecting) return;
      navLinks.forEach(function (a) {
        a.classList.toggle('active', a.getAttribute('href') === '#' + entry.target.id);
      });
    });
  }, { rootMargin: '-35% 0px -55% 0px' });
  sections.forEach(function (s) { spy.observe(s); });

  /* ----- hero line reveal on load ----- */
  setTimeout(function () {
    document.body.classList.add('loaded');
  }, 60);

  /* ----- scroll reveal (text blocks, curtains, staggered grids) ----- */
  var revealer = new IntersectionObserver(function (entries) {
    entries.forEach(function (entry) {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
        revealer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.12, rootMargin: '0px 0px -4% 0px' });
  document.querySelectorAll('.reveal, .curtain, .stagger').forEach(function (el) { revealer.observe(el); });

  /* ----- scroll progress line ----- */
  var progress = document.getElementById('progress');
  var reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  /* ----- parallax drift ----- */
  var pxEls = Array.prototype.slice.call(document.querySelectorAll('[data-parallax]'));
  var ticking = false;

  function paint() {
    ticking = false;
    var doc = document.documentElement;
    var max = doc.scrollHeight - innerHeight;
    progress.style.transform = 'scaleX(' + (max > 0 ? window.scrollY / max : 0) + ')';
    if (reduceMotion) return;
    var mid = innerHeight / 2;
    pxEls.forEach(function (el) {
      var r = el.getBoundingClientRect();
      if (r.bottom < -200 || r.top > innerHeight + 200) return;
      var offset = (r.top + r.height / 2 - mid) * parseFloat(el.getAttribute('data-parallax'));
      el.style.transform = 'translate3d(0,' + offset.toFixed(1) + 'px,0)';
    });
  }
  function requestPaint() {
    if (!ticking) { ticking = true; requestAnimationFrame(paint); }
  }
  window.addEventListener('scroll', requestPaint, { passive: true });
  window.addEventListener('resize', requestPaint, { passive: true });
  requestPaint();

  /* ----- lightbox ----- */
  var lb = document.getElementById('lightbox');
  var lbImg = document.getElementById('lbImg');
  var lbCaption = document.getElementById('lbCaption');
  var lbCount = document.getElementById('lbCount');
  var btnClose = document.getElementById('lbClose');
  var btnPrev = document.getElementById('lbPrev');
  var btnNext = document.getElementById('lbNext');

  var triggers = Array.prototype.slice.call(document.querySelectorAll('a.glb'));
  var galleries = {};
  triggers.forEach(function (a) {
    var g = a.getAttribute('data-gallery');
    (galleries[g] = galleries[g] || []).push(a);
  });

  var current = { gallery: null, index: 0, opener: null };

  function show(gallery, index) {
    var items = galleries[gallery];
    if (!items || !items.length) return;
    var n = items.length;
    index = ((index % n) + n) % n;
    current.gallery = gallery;
    current.index = index;
    var a = items[index];
    lbImg.src = a.getAttribute('href');
    var thumb = a.querySelector('img');
    lbImg.alt = thumb ? thumb.alt : (a.getAttribute('data-caption') || '');
    lbCaption.textContent = a.getAttribute('data-caption') || '';
    lbCount.textContent = n > 1 ? (index + 1) + ' / ' + n : '';
    var multi = n > 1;
    btnPrev.style.display = multi ? '' : 'none';
    btnNext.style.display = multi ? '' : 'none';
  }

  function open(gallery, index, opener) {
    current.opener = opener || null;
    show(gallery, index);
    lb.hidden = false;
    document.body.style.overflow = 'hidden';
    btnClose.focus();
  }

  function close() {
    lb.hidden = true;
    lbImg.src = '';
    document.body.style.overflow = '';
    if (current.opener) current.opener.focus();
  }

  triggers.forEach(function (a) {
    a.addEventListener('click', function (e) {
      e.preventDefault();
      var g = a.getAttribute('data-gallery');
      open(g, galleries[g].indexOf(a), a);
    });
  });

  btnClose.addEventListener('click', close);
  btnPrev.addEventListener('click', function () { show(current.gallery, current.index - 1); });
  btnNext.addEventListener('click', function () { show(current.gallery, current.index + 1); });

  lb.addEventListener('click', function (e) {
    if (e.target === lb) close();
  });

  document.addEventListener('keydown', function (e) {
    if (lb.hidden) return;
    if (e.key === 'Escape') close();
    else if (e.key === 'ArrowLeft') show(current.gallery, current.index - 1);
    else if (e.key === 'ArrowRight') show(current.gallery, current.index + 1);
    else if (e.key === 'Tab') {
      // keep focus inside the dialog
      var focusables = [btnClose, btnPrev, btnNext].filter(function (b) {
        return b.style.display !== 'none';
      });
      var i = focusables.indexOf(document.activeElement);
      if (e.shiftKey && (i <= 0)) { e.preventDefault(); focusables[focusables.length - 1].focus(); }
      else if (!e.shiftKey && i === focusables.length - 1) { e.preventDefault(); focusables[0].focus(); }
    }
  });

  /* swipe support in lightbox */
  var touchX = null;
  lb.addEventListener('touchstart', function (e) {
    touchX = e.changedTouches[0].clientX;
  }, { passive: true });
  lb.addEventListener('touchend', function (e) {
    if (touchX === null) return;
    var dx = e.changedTouches[0].clientX - touchX;
    if (Math.abs(dx) > 48) show(current.gallery, current.index + (dx < 0 ? 1 : -1));
    touchX = null;
  }, { passive: true });
})();
