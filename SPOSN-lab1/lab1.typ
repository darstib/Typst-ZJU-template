#import "../zju-template/lib.typ": template
#import "@preview/tablem:0.2.0": tablem, three-line-table

#set page(numbering: "1 / 1")


#show: template.with(
  title: [Lab 1 - Prompt Marketplace Analytics \ #text(size: 0pt)[.] \ #text(size: 18pt)[Characterizing the Prompt Marketplace - PromptBase]],
  course: text(size: 12pt)[Security and Privacy in Online Social Network],
  authors: (
    (
      name: "Jiangbo Deng",
      id: "3230102347",
      institution: "Information Security 2301",
      mail: "darstib@zju.edu.cn",
    ),
  ),
  // article_type: "",
  abstract: "abstract content",
  columns: 2,
)

#pagebreak()

= Summary

The process began by identifying the target seller, Aseria (Rank #34 on the leaderboard), based on the provided student ID calculation. Basic seller information was gathered manually. Subsequently, a systematic data collection methodology was employed: the seller's profile page was saved, all 400 unique prompt URLs were extracted using Python regex, and detailed information for each prompt (including name, description, tags, price, model, rating, likes, views, word count) was scraped using Python with Selenium, implementing throttling to avoid server issues and storing data initially in an SQL database. The collected raw data underwent preprocessing for cleaning and type correction (handling NaNs, converting types) to prepare it for analysis.

Analysis of the cleaned dataset revealed key characteristics of Aseria's profile and strategy. Findings indicate Aseria is a prolific seller specializing exclusively in *Midjourney* prompts, particularly favoring recent versions (V5.2, V5.1, V6.0). Thematic analysis of titles and descriptions showed a strong focus on "illustrations," "art," "drawings," and "abstract" styles, often highlighting use cases like "book" illustrations or "bundles." Prompts generally maintain moderate length (average 40 words). Aseria utilizes a distinct tiered pricing strategy, primarily using` $3.99` and `$2.99` price points. Engagement metrics (likes, views) displayed high variability and a strong positive correlation (0.78), suggesting a subset of prompts garners significantly more attention. User ratings, though sparse (30/400), were overwhelmingly positive (mean 4.8).

Through this process, practical experience was gained in web scraping dynamic websites (using Selenium), data cleaning, and applying various analytical techniques (distribution analysis, text analysis via WordCloud/TF-IDF, correlation analysis) to understand seller behavior and content strategy within a niche online marketplace. The lab provided valuable insights into the structure and characteristics of the emerging prompt economy.

= Background

The recent surge in capabilities of generative AI models, particularly LLMs, has not only transformed various industries but also catalyzed the formation of novel digital ecosystems. Central to interacting effectively with these powerful models is the art and science of prompt engineering—crafting precise instructions to elicit desired outputs. Recognizing the value inherent in well-designed prompts, online marketplaces dedicated to their exchange, such as PromptBase, have emerged. These platforms facilitate a burgeoning economy where creators can monetize their prompt engineering skills, and users can acquire effective prompts to enhance AI-driven tasks, ranging from content creation and code generation to complex problem-solving.Understanding the operational dynamics of these nascent marketplaces is crucial for researchers, platform developers, participants, and potentially regulators.

= Data Collection Methodology

#[#show figure.caption: set align(left)
  #figure(
    placement: top,
    scope: "parent",
    image("imgs/sposn-lab1-data_collect.png", width: 100%),
    caption: [Work flow, python scripts and files of data collection process for the analysis of PromptBase seller profile.
      The left panel outlines the sequential steps taken, from seller identification to final data preparation. The right panels illustrate the Python scripts (code folder) employed and the corresponding input/output files (files folder) generated at each stage, indicating dependencies and the platforms/tools involved.],
  )<img:data_collec-work_flow>]

The process of data collection for the analysis of PromptBase seller profile is shown in the @img:data_collec-work_flow.

+ The data collection process commenced by identifying the target seller, designated as \#34 based on the student ID modulus 69 #footnote[69 might represent the number of people in the DingTalk group, I guess.], from the PromptBase leaderboard.

+ This led to the seller's main profile page at `https://promptbase.com/profile/aseria` and I manually navigated to this profile page.

+ To ensure all prompts were captured, the page was scrolled continuously until the *Newest Prompts* section was fully loaded. The complete HTML source was then saved locally as `files/aseria_PromptBase_Profile.html`.

+ Using regular expressions, the Python script `code/prompt-url_get.py` was utilized to extract all individual prompt URLs matching the format `https://promptbase.com/prompt/*` from the saved HTML file. These URLs were compiled into the intermediate file `files/prompt_list.csv`.

+ The core data extraction involved executing the `code/crawling-extract.py` script. This script systematically visited each URL from `prompt_list.csv`, employing the `Selenium` library to collect detailed information for each prompt. Attributes gathered included the prompt's *name*, *rating* (handling cases where it was unavailable), *number of likes*, *word count*, *associated tags*, *full description*, *price*, *model type*, and *model version*. To ensure responsible data collection and avoid server issues, appropriate delays (throttling) were implemented. The script was also designed to handle potential network interruptions by recording progress, allowing for execution to resume from the point of failure. The collected attributes for each prompt were initially structured and stored in an SQL format within `files/prompts.db`.

+ To avoid missing some URLs due to some problems, I verified the `files/promtp.db` with `code/check_missing_url.py`. After ensuring there were no errors, the structured data was converted from the database format into the `files/prompts.csv` file using the `code/db2csv.py` script, preparing it for further analysis presented in this report.

+ Consequently, a data preprocessing pipeline using python script `code/data_clean.py` was implemented to enhance data integrity and facilitate robust analysis. Numeric features (`rating`, `likes`, `views`, `word_count`, `price`) were converted to appropriate numeric types using `pd.to_numeric`, handling potential conversion errors by coercing them to NaN values. Missing data within engagement and count metrics (`likes`, `views`, `word_count`) were imputed with zero, based on the assumption that missingness signifies an absence of the measured activity. The single missing `price` value was similarly imputed with 0.0, denoting a free prompt. Missing `rating` values were intentionally preserved as NaNs to represent unevaluated prompts accurately. Subsequently, `likes`, `views`, and `word_count` were cast to integer types. Textual features (`name`, `description`, `tags`, `model_type`) were standardized to string format, ensuring uniformity and handling any residual NaNs by replacing them with empty strings.This preprocessing effectively addressed data type inconsistencies and managed missing values according to the defined strategy.

= Data Description

As my student ID is 32301, I selected the seller with ID \#34 from the PromptBase leaderboard for this analysis. The \#34 seller is #link("https://promptbase.com/profile/aseria")[Aseria], a prompt engineer who joined PromptBase in February 2023. As shown in @table:seller_info, she specializes in Midjourney prompts, particularly for pattern design, and also offer expertise in refining AI-generated images using Photoshop to fix artifacts or ensure seamlessness. Aseria has garnered significant attention with 48.1k views and 3.9k likes, achieving 624 sales and 133 followers while maintaining a high score of 4.9.

#[#show figure.caption: set align(left)
  #figure(
    three-line-table[
      | *item* | views | likes | #text(size: 8pt)[downloads] | sales | score | follower |
      | :----: | :---: | :---: | :---: | :---: | :---: | :---: |
      | *info* | 241 | 3.9k | 244 | 624 | 4.9 | 133 |
    ],
    caption: [Basic information of the seller (Aseria, Rank \#34) on PromptBase, joined Feb 2023. Summarizes key performance metrics, highlighting a high score (4.9) and significant sales/likes],
  )<table:seller_info>]

The resultant prompts underpinning this analysis, stored in `files/prompts.csv`, consisted of 400 records, each representing a unique prompt, characterized by 11 distinct features#footnote["id" was excluded.]. These features encompass identifiers (*`url`, `name`*), user engagement metrics (*`rating`, `likes`, `views`*), content characteristics (*`word_count`, `tags`, `description`*), commercial details (*`price`*), and technical specifications (*`model_type`, `model_version`*).

An initial assessment of the raw dataset revealed specific data quality aspects requiring attention prior to analysis. Examination via `pandas.DataFrame.info()` indicated the presence of missing values#footnote[The missing is caused by the lack of relevant information on the platform, not by abnormal crawling], most prominently within the `rating` feature (370 missing entries, 92.5%) and to a lesser extent in `likes` (26 missing entries, 6.5%) and `price` (1 missing entry#footnote[In fact, it's just because the corresponding prompt is free.] 0.25%). All other data types are intact. Of course, the data was then cleaned at the end of the data collection process for analysis.

A summary of the numerical data reveals considerable variability in engagement metrics; for instance, `views` range from 4 to 1900 (mean 78.96, std 150.52), while `likes` range from 0 to 83 (mean 7.88, std 8.30). Prompt `word_count` varies between 17 and 112 words (mean 40.56, std 13.09), and `price` ranges from 0.00 to 7.99 (mean 3.88, std 0.72). The `rating` feature, despite its missingness, shows a high mean of 4.80 among the 30 available ratings.

// These statistics provide a foundational overview of the seller's prompt characteristics and associated metrics.

These statistics provide a foundational overview of the seller and her prompts.

= Data Analysis and Findings

This section presents a multi-faceted analysis of the collected prompt data, examining attribute distributions, content characteristics, and user engagement patterns to construct a comprehensive profile of the target seller. The analysis integrates statistical summaries and data visualizations generated from the accompanying notebook (`files/data_analysis.ipynb`)#footnote[#lorem(20)].

#[#show figure.caption: set align(left)
  #figure(
    placement: auto,
    scope: "parent",
    three-line-table(column-gutter: 8%)[
      | *data\\item* | *rating* | *likes* | *views* | *word_count* | *price* |
      | :---: | :------: | :-----: | :-----: | :--------: | :------: |
      | *count* | 30 | 400 | 400 | 400 | 400 |
      | *mean* | 4.800 | 7.875 | 78.955 | 40.560 | 3.875 |
      | *std* | 0.761 | 8.305 | 150.518 | 13.095 | 0.720 |
      | *min* | 1 | 0 | 4 | 17 | 0 |
      | *25%* | 5 | 2 | 23.75 | 32 | 2.99 |
      | *50%* | 5 | 5 | 41 | 38 | 3.99 |
      | *75%* | 5 | 12 | 73.25 | 47 | 3.99 |
      | *max* | 5 | 83 | 1900 | 112 | 7.99 |
    ],
    caption: "Data distribution of the seller's prompts, including rating, likes, views, word count and price. The table summarizes the key statistics for each attribute.",
  )<table:data_distribution>]

== Distribution Analysis

@table:data_distribution shows a simple *descriptive* analysis of the fundamental attributes of the seller's 400 prompts.

#[#show figure.caption: set align(left)
  #figure(
    placement: auto,
    scope: "parent",
    image("imgs/word_count_dist.png", width: 80%),
    caption: [Distribution of Prompt Word Count for Aseria's 400 prompts. Shows a roughly normal shape, slightly right-skewed, indicating most prompts have moderate length (32-47 words) rather than being very brief or verbose.],
  )<img:word_count_dist>]

- *word count / Prompt Length:* The word count of prompts exhibits a distribution centered around a mean of `40.56` words, with a standard deviation of `13.10` (as shown in @table:data_distribution). @img:word_count_dist shows a roughly normal distribution, albeit slightly right-skewed, with the bulk of prompts falling between `32` and `47` words. This suggests the seller's approach to prompt detail: avoiding excessive brevity or verbosity.

- *Pricing Strategy:* As shown in @table:price_count, only 1 out of 400 prompts offered for free, and the pricing for paid prompts is highly concentrated. The most frequent price points appear to be `$3.99` (241 prompts) and `$2.99` (105 prompts). The mean price is slightly higher at `$3.875`. This may indicate a defined, tiered pricing structure rather than highly variable pricing.

#[#show figure.caption: set align(left)
  #figure(
    three-line-table[
      | *Price(\$)* | 3.99 | 2.99 | 4.99 | 5.99 | 7.99 | 6.99 | 0.00 |
      | :-------: | :---: | :---: | :---: | :---: | :---: | :---: | :---:|
      | *Count* | 241 | 105 | 46 | 5 | 1 | < | < |
    ],
    caption: [Price Counts for 400 prompts. Clearly shows a dominant tiered strategy with \$3.99 and \$2.99 being the most frequent price points.],
  )<table:price_count>]

- *Model Usage:* The data demonstrates the seller's exclusive focus on the Midjourney model. Analysis of the standardized model versions reveals a clear preference for specific iterations (@table:model_version_counts). Version '5.2' is the most prevalent (153 prompts), followed by '5.1' (79 prompts), and then roughly equal usage of '5' (56), '6.0' (56), and '4' (27). Usage of 'NIJI' (18) and '6.1' (11) is less frequent. This pattern suggests the seller actively utilizes newer model versions while maintaining a portfolio across several key iterations.

#figure(
  // placement: auto,
  three-line-table[
    | #text(size: 6pt)[*Model Version*] | V5.2 | V5.1 | V5 | V6.0 | V4 | NIJI | V6.1 |
    | :-------------: | :---: | :---: | :-: | :---: | :-: | :--: | :---: |
    | #text(size: 8pt)[*Frequency*] | 153 | 79 | 56 | 56 | 27 | 18 | 11 |
  ],
  caption: [Model Versions Value Counts.],
)<table:model_version_counts>

- *Tags Frequency:* Tags offer user-facing categorization. As shown in @table:top_tags, the most frequent tags are functional descriptors: 'Tested'#footnote[It was set by the platform to indicate that it has been verified and is meaningless.] (400), 'HD images' (400), 'Free credits' (399), and 'Instructions' (385). 'No artists' (294) is also highly common, but '9 examples' appears less frequently (23). Unfortunately, I failed to discern many valid speculations from it.

#figure(
  placement: bottom,
  scope: "parent",
  three-line-table(column-gutter: 3%)[
    | *Tag* | Tested | HD images | Free credits | Instructions | No artists | 9 examples |
    | :----------- | :----: | :-------: | :----------: | :----------: | :--------: | :--------: |
    | *Frequency* | 400 | 400 | 399 | 385 | 294 | 23 |
  ],
  caption: [Tags frequency], // Updated caption to reflect actual number shown
)<table:top_tags>


== Content Style Analysis

An examination of the textual content may provide insights into the seller's artistic focus and descriptive style to help us understand the seller's approach to prompt engineering.

- *Title Keywords:* Word cloud of prompt titles shown in @img:title_keywords highlights 'illustrations' as the dominant keyword (93 occurrences), followed by 'art' (47), 'drawings' (25), 'paintings' (21), and 'abstract' (20). Other notable terms include 'photos' (19), 'patterns' (17), and 'cute' (12). This points towards a primary focus on generating illustrative and artistic imagery, with a significant abstract component.

#[#show figure.caption: set align(left)
  #figure(
    placement: auto,
    scope: "parent",
    image("imgs/title_wordcloud.png", width: 80%),
    // image("imgs/title_keywords.png", width: 75%),
    caption: [Word cloud of the words (excluding common stopwords) in Aseria's prompt titles. The prevalence of 'illustrations', 'art', 'drawings', and 'abstract' strongly indicates a focus on generating artistic and illustrative imagery.],
  )<img:title_keywords>]

- *Description Analysis (TF-IDF):* TF-IDF analysis (shown in @img:tfidf_terms), which weighs term importance, reinforces the prominence of 'illustrations' (Score: 54.06) but also elevates terms potentially indicative of specific offerings or marketing language. Terms like 'book' (46.81), 'bundle' (33.52), 'prompts' (32.89), and 'buy' (32.59) achieve high scores. N-grams such as 'examples included' (25.67), 'poster websites' (24.96), and 'educational materials' (24.96) also appear, suggesting the seller emphasizes provided examples and potential use cases within descriptions. This hints at both the content generated (illustrations for books) and the commercial presentation (bundles, examples).

#[#show figure.caption: set align(left)
  #figure(
    placement: auto,
    scope: "parent",
    image("imgs/tfidf_terms.png", width: 85%),
    caption: [Top 20 Terms in Descriptions by TF-IDF Score, highlighting important and relatively unique words. Reveals a mix of content focus ('illustrations', 'book') and marketing/structural terms ('bundle', 'buy', 'examples included').],
  )<img:tfidf_terms>]

== Engagement Metrics

User interaction metrics offer a perspective on prompt reception, although data limitations exist.

#figure(
  // placement: auto,
  three-line-table(column-gutter: 5%)[
    | Rating | 5 | 4 | 1 |
    | ------ | --- | --- | --- |
    | Count | 1 | 2 | 27 |
  ],
  caption: [Rating Counts],
)<table:rating_count>

- *Ratings:* Only 30 prompts received ratings. Among these, the distribution shown in @table:rating_count is heavily skewed towards the maximum score of 5 (mean: 4.80, std: 0.76, shown in @table:data_distribution). While positive, the low volume of ratings limits definite conclusions about overall viewer and purchaser satisfaction.

// #figure(
//     image("imgs/rating_dist.png", width: 100%),
//     caption: [Distribution of Prompt Ratings.]
// )<table:rating_count>

- *Likes and Views:* Likes range up to 83 (mean 7.88) and views up to 1900 (mean 78.96) as shown in @table:data_distribution. Both distributions (@img:likes_dist, @img:views_dist) are strongly right-skewed, indicating that a small number of prompts garner significantly higher engagement. The high standard deviations relative to the means confirm this variability.

#[#show figure.caption: set align(left)
  #figure(
    placement: auto,
    scope: "parent",
    image("imgs/likes_dist.png", width: 80%),
    caption: [Distribution of Prompt Likes (Log Scale). The logarithmic scale emphasizes the strong right-skew, indicating that a few prompts garner significantly more likes than the vast majority, reflecting high engagement variability.],
  )<img:likes_dist>]

#[#show figure.caption: set align(left)
  #figure(
    placement: auto,
    scope: "parent",
    image("imgs/views_dist.png", width: 80%),
    caption: [Distribution of Prompt Views (Log Scale). Similar to likes, the log scale highlights a strong right-skew where a small subset of prompts achieves much higher visibility compared to the rest.],
  )<img:views_dist>]

- *Correlations:* The correlation analysis shown in @img:correlation_heatmap reveals expected and nuanced relationships. A strong positive correlation (0.78) exists between `likes` and `views`, suggesting higher visibility often translates to more favorites. Weaker positive correlations are observed between `price` and both `likes` (0.27) and `views` (0.19), hinting that slightly higher-priced prompts might receive marginally more engagement, though this is not a strong trend. `word_count` shows minimal linear correlation with `likes` (-0.11) and `views` (-0.04), implying prompt length is not a primary driver of these engagement metrics. The correlation involving `rating` is weak and potentially unreliable due to the small sample size of 30 rated prompts.

#[#show figure.caption: set align(left)
  #figure(
    placement: auto,
    scope: "parent",
    image("imgs/correlation_heatmap.png", width: 60%),
    caption: [Correlation Matrix of numerical Prompt Attributes. Visualizes the strong positive relationship between likes and views (0.78), and weaker correlations elsewhere (e.g., price/word count vs engagement). Please pay attention to that rating correlations are unreliable due to N=30.],
  )<img:correlation_heatmap>]

== Summary of Findings

In summary, the seller demonstrates a prolific output (400 prompts) exclusively focused on the Midjourney model, particularly favoring recent versions like 5.2 and 5.1. The content centers around illustrative and artistic imagery, with 'illustrations', 'art', 'drawings', and 'abstract' being key title keywords. Descriptions often potential use cases ('book', 'poster', 'bundle'), as confirmed by TF-IDF analysis. Prompts are typically moderately detailed (mean 40 words).

The seller employs a clear, tiered pricing strategy, with the vast majority of prompts priced around `$2.99` & `$3.99`, and very few (1 out of 400) offered for free. Engagement metrics (likes, views) show significant variability, with a strong positive correlation between them, indicating that a subset of prompts attracts much higher attention.

= Miscellaneouss

== Crawling with checkpoints

As mentioned earlier, I was often restricted from accessing the website halfway during the crawling process, even though I controlled the time interval between each crawl within 8 to 10 seconds.

So I guess a smooth progress might be expected to take an interval of about 15 seconds (considering that I need to crawl 400 pieces, that would be nearly two hours, although this is not completely unacceptable).

However, I found that the target website restricted access by adding the IP to the blacklist, so I could continue the access by changing my IP.

To avoid missing the crawled information, I utilized artificial intelligence to assist me in continuing the task with *checkpoints*. Other codes also sometimes ask artificial intelligence for help if the job is repetitive and cumbersome.

== description generating tips with LLM

By the way, I use `Gemini-2.5-flash` to analysis and ask it to help me find the tips for generating great descriptions to better attract buyers, with the prompt and answer shown in *@appendix-b*.

Based on the LLM analysis, designing an effective prompt description involves starting with a clear, concise statement of what the prompt generates and highlighting customization options to show flexibility.

It is crucial to list specific use cases to help potential buyers understand the value and utility, while also confirming that examples and instructions are included to build confidence.

Enhancing readability with formatting like *line breaks and emojis*, incorporating calls to action such as mentioning bundles or subscriptions.

#pagebreak()

#set page(columns: 1)

#heading(numbering: none)[Appendix A: Relative files]

#figure(
  // placement: auto,
  // scope: "parent",
  three-line-table(column-gutter: 5%)[
    | folder | filename | function |
    | ------- | ---- | :----: |
    | code | `prompt-url_get.py` | extract prompt URLs from the saved HTML source. |
    | code | `crawling-extract.py` | using Selenium to scrape detailed prompt data from URLs. |
    | code | `check_missing_url.py` | verify completeness of crawled data stored in the database. |
    | code | `db2csv.py` | convert structured data from the SQL database to CSV format. |
    | code | `data_clean.py` | preprocess the raw CSV data for analysis and cleaning. |
    | files | `aseria_PromptBase_Profile.html` | Local copy of the HTML source for URL extraction. |
    | files | `prompt_list.csv` | Intermediate CSV file listing all unique prompt URLs. |
    | files | `prompts.db` | Initial storage of the scraped prompt data in an SQLite database.|
    | files | `prompts.csv` | Final dataset in CSV format used for subsequent data analysis. |
    | files | `data_analysis.ipynb` | Jupyter notebook for data analysis, visualization, and findings. |
    // | `imgs`  | (folder)                         |        Folder containing visualizations and figures generated by the analysis notebook.        |
  ],
  caption: [List of the code and files used in this report.],
)<table:file_list>

#heading(numbering: none)[Appendix B: LLM analysis prompt & answer]<appendix-b>

#text(fill: rgb("#4f7c9f"))[
  #heading(numbering: none, level: 2)[Prompt]<prompt>

  Analyze the `description` column in the attached CSV file (uploaded) in relation to the `likes`, `views`, `rating`, and potentially `price` columns.Identify the key characteristics, content elements, and writing styles of prompt descriptions that correlate with higher user engagement (specifically high `likes` and `views`) and potentially positive `rating`. Based on this analysis, list the essential components or strategies for writing a compelling prompt description that likely attracts buyers on this platform. Focus on actionable insights derived from the data.Provide the output as a list of key tips.
]

#text(fill: rgb("#144414"))[
  #heading(numbering: none, level: 2)[Answer]<answer>

  Based on the analysis of the provided CSV data, here are the essential components and strategies for writing a compelling prompt description that correlates with higher user engagement (`likes`, `views`) and potentially positive `rating` on this platform:

  Here is a list of key tips for writing a compelling prompt description:

  1. *Start with a Clear and Concise Statement:* Immediately state what the prompt generates. Many high-engagement descriptions begin with a clear phrase like "Generates [Prompt Name] of your choice." This immediately tells the potential buyer what they are getting.
  2. *Highlight Key Capabilities & Customization:* Explicitly mention what aspects the user can customize or influence (e.g., "of your choice," "You can change the colors," "You can choose..."). This empowers the user and demonstrates the prompt's flexibility.
  3. *Provide Specific Use Cases:* List various potential applications or contexts where the generated output can be used (e.g., "for book illustrations, as T-shirt design, Advertising, Educational Materials, book cover, a poster, for Websites, in Social Media, etc."). This helps buyers envision the value and utility of the prompt for their own needs. This element is extremely common in descriptions with high views and likes.
  4. *Confirm Examples are Included:* Users want to see what they can generate. Explicitly stating "Examples included!" (often repeated multiple times) is crucial and appears frequently in successful prompts.
  5. *Mention Instructions and Ease of Use:* Indicate that instructions are provided. This signals that the prompt is well-documented and easy for a buyer to get started with, reducing perceived friction.
  6. *Include Calls to Action (CTAs):* Encourage further engagement and purchases. Common CTAs found in higher-performing prompts include:
    - Promoting bundles or discounts ("Scroll down to buy the bundle with 25% off!", "IF YOU LIKE CERTAIN PROMPTS, I WILL PUT THEM TOGETHER IN A BUNDLE...").
    - Encouraging subscriptions ("Subscribe to me to be the first to know about new prompts!").
    - Offering personalized service ("I will assemble the bundle according to your desire! Write me!").
  7. *Use Formatting for Readability:* Break up text using line breaks, emojis (🌿, 🏷️, 🔔, 😃, 📢, 📌, ✨, 💸, 💥, 🎉, 💘, 💛, 📷), and potentially bullet points (especially for listing use cases or features). This makes the description easy to scan and digest.
  8. *Highlight Included Features:* While some features like "Free credits," "Tested," and "HD images" might be indicated by platform tags, repeating them in the description reinforces the value proposition and the quality/reliability of the prompt. Mentioning the specific AI model version used can also be beneficial.
  9. *Consider Adding a Personal Touch:* Some descriptions include brief personal notes (like the birthday example) or offers (like the "Buy 2 + review" offer). While not universal, these can help build a connection with potential buyers. (Note: The "Buy 2 + review" offer didn't guarantee high engagement in the samples, but personalization can still be a factor).

  In summary, effective prompt descriptions are clear about the output, demonstrate its utility through use cases, provide confidence by mentioning examples and instructions, and include calls to action to guide the buyer towards purchase or further engagement, all while being formatted for easy reading.]
