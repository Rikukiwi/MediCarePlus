document.addEventListener('DOMContentLoaded', function () {
    // Hamburger
    const btn = document.getElementById('hamburgerBtn');
    const menu = document.getElementById('mobileMenu');
    if (btn && menu) btn.addEventListener('click', () => menu.classList.toggle('open'));

    // Dynamic doctor filter by specialty (Booking)
    const specSel = document.getElementById('Specialty');
    const docSel  = document.getElementById('DoctorName');
    if (specSel && docSel) {
        specSel.addEventListener('change', function () {
            docSel.innerHTML = '<option value="">Bất kỳ bác sĩ</option>';
            if (!this.value) return;
            fetch('/Booking/GetDoctorsBySpecialty?specialty=' + encodeURIComponent(this.value))
                .then(r => r.json())
                .then(docs => docs.forEach(d => {
                    const o = document.createElement('option');
                    o.value = d.name; o.textContent = d.name;
                    docSel.appendChild(o);
                }));
        });
    }

    // Auto dismiss alert
    const alert = document.querySelector('.alert');
    if (alert) setTimeout(() => { alert.style.transition = 'opacity .4s'; alert.style.opacity = '0'; setTimeout(() => alert.remove(), 400); }, 6000);

    // Scroll reveal
    const obs = new IntersectionObserver(entries => entries.forEach(e => {
        if (e.isIntersecting) { e.target.style.opacity = '1'; e.target.style.transform = 'translateY(0)'; }
    }), { threshold: 0.1 });
    document.querySelectorAll('.service-card,.doctor-card,.why-card,.testimonial-card').forEach(el => {
        el.style.opacity = '0'; el.style.transform = 'translateY(24px)'; el.style.transition = 'opacity .5s,transform .5s';
        obs.observe(el);
    });
});
