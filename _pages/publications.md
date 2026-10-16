---
layout: page
permalink: /publications/
title: publications
description: in reverse chronological order. * denotes equal contribution.
nav: true
nav_order: 2
---

<!-- _pages/publications.md -->

<style>
  .publications .preview { max-height: 190px; width: auto; max-width: 100%; display: block; margin: 0 auto; pointer-events: none; }
  .topic-filters { display: flex; flex-wrap: wrap; gap: 0.5rem; margin-bottom: 1rem; }
  .topic-filters button {
    border: 1px solid var(--global-divider-color);
    background: transparent;
    color: var(--global-text-color);
    border-radius: 999px;
    padding: 0.25rem 0.85rem;
    font-size: 0.9rem;
    cursor: pointer;
  }
  .topic-filters button:hover { border-color: var(--global-theme-color); color: var(--global-theme-color); }
  .topic-filters button.active { background: var(--global-theme-color); border-color: var(--global-theme-color); color: var(--global-bg-color); }
  .topic-hidden { display: none !important; }
</style>

<!-- Topic filter: tags are keyed by the BibTeX key of each entry in _bibliography/papers.bib. -->
<div class="topic-filters" role="group" aria-label="Filter publications by topic">
  <button type="button" data-topic="all" class="active" aria-pressed="true">All</button>
  <button type="button" data-topic="eval" aria-pressed="false">LLM Evaluation &amp; Benchmarks</button>
  <button type="button" data-topic="health" aria-pressed="false">Healthcare NLP</button>
  <button type="button" data-topic="ner" aria-pressed="false">Zero-shot NER &amp; Synthetic Data</button>
</div>

<!-- Bibsearch Feature -->

{% include bib_search.liquid %}

<div class="publications">

{% bibliography %}

</div>

<script>
  (function () {
    const topics = {
      zangrillo2026paintitblack: ["eval", "health"],
      cocchieri2026lostinchoice: ["eval"],
      "DBLP:conf/acl/CocchieriRTM26": ["eval", "health"],
      "DBLP:conf/acl/MolfettaCRBPM26": ["eval"],
      cocchieri2026jab: ["eval"],
      "DBLP:journals/eswa/CocchieriFZRGTM26": ["health", "ner"],
      "DBLP:conf/eacl/CocchieriRTM26": ["eval", "health"],
      "DBLP:conf/acl/CocchieriGFM0T25": ["ner"],
      "DBLP:conf/acl/CocchieriRITM25": ["eval"],
      "DBLP:conf/emnlp/CocchieriRTTCM25": ["eval"],
      "DBLP:conf/naacl/CocchieriFGMTC25": ["health", "ner"],
      "DBLP:conf/acl/FrisoniCPMM24": ["health"],
    };
    const buttons = document.querySelectorAll(".topic-filters button");

    function apply(topic) {
      document.querySelectorAll(".publications ol.bibliography > li").forEach((li) => {
        const entry = li.querySelector("[id]");
        const tags = (entry && topics[entry.id]) || [];
        li.classList.toggle("topic-hidden", topic !== "all" && !tags.includes(topic));
      });
      // Hide a year heading when none of its entries match.
      document.querySelectorAll(".publications h2.bibliography").forEach((h2) => {
        const ol = h2.nextElementSibling;
        const empty = ol && ol.querySelectorAll(":scope > li:not(.topic-hidden)").length === 0;
        h2.classList.toggle("topic-hidden", empty);
        if (ol) ol.classList.toggle("topic-hidden", empty);
      });
      buttons.forEach((b) => {
        const on = b.dataset.topic === topic;
        b.classList.toggle("active", on);
        b.setAttribute("aria-pressed", on);
      });
    }

    buttons.forEach((b) => b.addEventListener("click", () => apply(b.dataset.topic)));
  })();
</script>
