---
layout: post
title: Two papers accepted at EMNLP 2026!
date: 2026-08-21 09:00:00+0100
inline: false
related_posts: false
---

Two of our papers have been accepted at <a href="https://2026.emnlp.org/">EMNLP 2026</a> (Conference on Empirical Methods in Natural Language Processing), to be held in **Budapest, Hungary**. This will be my last conference as a PhD student.

---

**Paint It Black: Evaluating LLMs for De-Identification of Multimodal Clinical Documents** (Main Conference)
<br>F. Zangrillo, A. Cocchieri, G. Frisoni, D. Freddi, L. Ragazzi, G. Moro

A collaboration with Sant'Orsola Hospital in Bologna. Clinical documents are inherently multimodal: sensitive information can be embedded anywhere across their text, layout, and visual elements. We introduce Paint-It-Black (PIB), the first benchmark for evaluating the native multimodal capabilities of MLLMs for end-to-end, pixel-level PHI de-identification in clinical PDFs. The fully open-source dataset consists of synthetic clinical documents mimicking real-world cases and diverse hospital layouts, with clinical realism validated by practicing physicians, alongside controlled visual degradations and fine-grained, HIPAA-aligned bounding-box annotations. Even strong open-source MLLMs remain far from the reliability required for clinical deployment. <a href="https://disi-unibo-nlp.github.io/paint-it-black/">Project page</a>.

---

**Lost in Choice: Evaluating LLMs Under Extreme Multiple-Choice Scaling** (Findings)
<br>A. Cocchieri, L. Ragazzi, G. Tagliavini, G. Moro

We systematically study how LLM selection changes as the number of multiple-choice options grows from 10 to 1,000, across comparison dependency, candidate cardinality, spatial layout, and answer position. We uncover two failure modes: performance collapses as options become numerous and spatially dispersed ("Lost in Choice"), and models can struggle more with just 10 options requiring comparative reasoning than with 1,000 options answerable through simple factual recall (the "Reasoning&ndash;Context Paradox"). We further reproduce the same positional collapse on real ToolBench tool-selection trajectories. <a href="https://disi-unibo-nlp.github.io/lost-in-choice/">Project page</a>.
