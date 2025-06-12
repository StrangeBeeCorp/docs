document.addEventListener('DOMContentLoaded', () => {
  const homeLinks = document.querySelectorAll('a[href="/"]');
  homeLinks.forEach(link => {
    link.addEventListener('click', e => {
      e.preventDefault();
      window.location.href = '/';
    });
  });
});