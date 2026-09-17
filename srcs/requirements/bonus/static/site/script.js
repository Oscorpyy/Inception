document.addEventListener("DOMContentLoaded", () => {
    const legsContainer = document.getElementById("legsContainer");
    const sentinel = document.getElementById("sentinel");
    const depthMeter = document.getElementById("depthMeter");
    const segmentCountEl = document.getElementById("segmentCount");
    const btnTop = document.getElementById("btnTop");

    let totalSegments = 0;
    let isLoading = false;

    const milestones = {
        5: "🌾 50m - Still close to the surface grass...",
        10: "☁️ 100m - Leg physics are holding up.",
        25: "🐄 250m - Somewhere above, a cow is mooing.",
        50: "🕳️ 500m - Still looking for the hooves? Good luck!",
        75: "🔭 750m - Scientists confirm: legs have no bottom.",
        100: "🚀 1,000m - Entering the deep leg atmosphere.",
        142: "🪐 1,420m - 42 School easter-egg: Leg dimension achieved!",
        200: "🌌 2,000m - Infinite legs, infinite possibilities.",
        300: "🛸 3,000m - Even aliens are confused by these legs.",
        500: "⭐ 5,000m - Legendary Leg Scroller!"
    };

    function createLegSegment(index) {
        const segment = document.createElement("div");
        segment.className = "leg-segment";

        for (let i = 1; i <= 4; i++) {
            const leg = document.createElement("div");
            leg.className = `leg leg-${i}`;

            if (Math.random() < 0.35) {
                const spot = document.createElement("div");
                spot.className = "leg-spot";
                const w = Math.floor(Math.random() * 20) + 16;
                const h = Math.floor(Math.random() * 40) + 20;
                const top = Math.floor(Math.random() * 110) + 10;
                const left = (Math.random() > 0.5) ? "-5px" : "12px";

                spot.style.width = `${w}px`;
                spot.style.height = `${h}px`;
                spot.style.top = `${top}px`;
                spot.style.left = left;
                spot.style.borderRadius = `${Math.random() * 40 + 30}% ${Math.random() * 40 + 30}%`;

                leg.appendChild(spot);
            }

            segment.appendChild(leg);
        }

        if (milestones[index]) {
            const badge = document.createElement("div");
            badge.className = "milestone-badge";
            badge.textContent = milestones[index];
            segment.appendChild(badge);
        }

        return segment;
    }

    function loadMoreSegments(count = 10) {
        if (isLoading) return;
        isLoading = true;

        const fragment = document.createDocumentFragment();
        for (let i = 0; i < count; i++) {
            totalSegments++;
            fragment.appendChild(createLegSegment(totalSegments));
        }

        legsContainer.appendChild(fragment);
        segmentCountEl.textContent = totalSegments;
        isLoading = false;
    }

    const observer = new IntersectionObserver((entries) => {
        entries.forEach((entry) => {
            if (entry.isIntersecting) {
                loadMoreSegments(12);
            }
        });
    }, {
        rootMargin: "600px"
    });

    observer.observe(sentinel);

    loadMoreSegments(12);

    window.addEventListener("scroll", () => {
        const scrollY = window.scrollY || window.pageYOffset;
        const meters = Math.floor(scrollY / 4);
        depthMeter.textContent = `${meters.toLocaleString()} m`;
    }, { passive: true });

    btnTop.addEventListener("click", () => {
        window.scrollTo({ top: 0, behavior: "smooth" });
    });
});
