# fetch-take-home

### Summary: Include screen shots or a video of your app highlighting its features

Here's a video highlighting the app's main features:

https://www.dropbox.com/scl/fi/t8hzy6suefu9tyyref2pd/ScreenRecording_02-28-2025-15-14-41_1.mov?rlkey=qghpofsggrd8lvzvdhwmqek1b&st=cmjletyb&dl=0

First part shows the entire RecipeListView as intended. Then it shows how searching and filtering work, as well as the buttons that link to the YouTube videos, website, and a share button to share the recipe with friends.

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

I chose to focus on making sure that I satisfied the technical requirements set out in the document I was given as well as give users a pleasant user experience. I thought that given the amount of data that the API is currently calling, it would make more sense to focus on making sure customers are able to easily find and discover recipes rather than optimizing image/data load. Another area of focus was ensuring that the code was decomposed properly so that engineers can easily read and add to the code in the future, although I believe there could be improvements in the Network layer on that end.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?

In total, I spent about 5 hours on this project. 

The first hour was spent planning as well as writing the model for Recipe and building a basic UI View. The next two hours were spent writing the View Model, Network, and Image Caching to ensure that data was loading correctly or giving me the correct errors.
The next hour was spent making the UI a bit nicer and adding additional functionality such as search and filter. 
The last hour was spent writing test cases and making sure the code was decomposed well.

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?

Some significant decisions that I had to make were regarding the UI and whether I wanted larger images or smaller images for the cards. I felt that the card that I made balanced both having a visual of the dish as well as the important information and buttons to share or watch the recipe. Additionally, a smaller image would hopefully lead towards less memory used on the disk as this was the caching method used.

Another tradeoff was deciding not to write functions to remove cache with the time I had. If I had more time I would definitely implement and test removing from cache so that it’d be more scalable for even more images. I was also considering adding memory caching for a two-tiered system, but again this was another tradeoff that would lead to some performance optimizations but would not necessarily lead to a better UX for the data we were working with.

### Weakest Part of the Project: What do you think is the weakest part of your project?

I think that the weakest part of the project was the UI design. I opted for a simpler design so that it would look serviceable, but I believe that it could use a change in the color scheme/choices so that it looks better, and I believe there are user experience optimizations I can make so that it’s more intuitive. I also can imagine that the cards would not look great if there was an extremely long recipe name, as the ones that were in the data were a reasonable length. I would be extremely excited to work on teams with multiple stakeholders at Fetch, as it would allow me to learn and get a better sense of parts of my development that are weaker such as my design skills. Additionally, working with senior engineers would help me laern how to build frontend views that are scalable for different types of data.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.

I believe I put my best foot forward in writing production level code, but there are some spots where I would have definitely changed things if this were a larger project and I had more time. For example, I would want to write a generic network layer that can work with any endpoint and get/put data. I also tried my best to follow MVVM but have not written Swift outside of startups where I was sometimes the sole technical member of the team, so I'm not sure if the way I decomposed things completely correctly, but I am always open to feedback and want to improve as a developer!

In all, I really enjoyed working on this project! Looking forward to hearing back.
