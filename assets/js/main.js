document.addEventListener('click', e=>{
    if(e.target.matches('.md-search__overlay')) {
        let x = document.querySelector('[data-md-toggle=search]:checked');
        x.checked = 0; setTimeout(x=>x.checked = 0, 100, x);
        document.activeElement.blur();
    }    
});

(()=>{
    var initMarker = false;
        function initMarkers() {
            [...document.querySelectorAll('[data-marker]')].forEach(marker => {
                var list = marker.querySelector('.list');
                var mark = marker.querySelector('[data-mark]');
                list.style.setProperty('--marker-h', '0px');

                if (!mark.hasListener) {
                    mark.addEventListener('click', () => {
                        var isExpanded = marker.classList.contains('expand');

                        if (isExpanded) {
                            marker.classList.remove('expand');
                            list.style.setProperty('--marker-h', '0px');
                        } else {
                            var inner = list.firstElementChild;
                            var height = inner.scrollHeight + 'px';
                            marker.classList.add('expand');
                            list.style.setProperty('--marker-h', height);
                        }
                    });
                    mark.hasListener = true;
                }
            });
            initMarker = true;
        }

        function resetMarkers() {
            [...document.querySelectorAll('[data-marker]')].forEach(marker => {
                marker.classList.remove('expand');
                marker.querySelector('.list').style.setProperty('--marker-h', '');
            });
            initMarker = false;
        }

        function checkMarkers() {
            if (window.innerWidth <= 768 && !initMarker) initMarkers();
            else if (window.innerWidth > 768 && initMarker) resetMarkers();
        }

        window.addEventListener('DOMContentLoaded', checkMarkers);
        window.addEventListener('resize', checkMarkers);
})();