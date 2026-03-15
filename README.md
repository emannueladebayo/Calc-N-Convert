**My_internship_application_project**
- Good day to you who's reading this.
I'm Emmanuel Adebayo Aladenika and this is my internship application assessment project(hope the name's not too long 😅).

- The task given was to develop and app with 2 tabs.
One being a Calculator and the other being a Currency converter.

- This is a documentation containing all there is to know about the project as well as how i was able to get it all done.

**FRAMEWORK**
- This application was built using flutter framework. Love the UI approach especially for someone like me who's still trying to get the hang of everything design(placements, color mixing etc)
- Dependecies used: math_expressions and http.

**TECH FEATURES**
- My app features regex parsing for the calculator("a newly leant knowledge for me"). A feature I learned and used when trying to debug an error i got during the coding process which deals with "n-th root" logic.
- Also features the use of exchangerate API to fetch instant currency exchange data.(Also newly learnt).

**TIME**
- I spent a total of **9 hours** across 3 days(friday, saturday and sunday).
A gathered total of an hour was used to think up and draw how I'd love my app to look like and how it should function.

- Thinking about the calculator logic took most of the time and even trying to implement it took much more time. Why?

- I included the basic arithmetic operations(+, x, -, ÷) as well as the logic behind them(BODMAS) and also replacement texts for (x and ÷) to be (* and /) because i had someone test my app on their phone to get feedback and saw there was an error when one of the replacement signs was used.

**HOW TO USE**
- **Calculator:**
    - Pretty simple to use. 
    - Contains basic arithmetic operations(BODMAS)
    - Instead of square root or cube root functions separately, after thinking for sometime, I decided to make it a single function "nth-root" or in the app "()√". This way you can find any root of any number you want. The 5th-root of any number can be found this way and by doing that I believe I've made my app have a broader use.
    - Same with squares and cubes of numbers. I just represented this with a single function that can perform all of that and that is the "^" sign. So you can do more than squares and cubes, 3^4 = 81 is possible this way.
    - You can also edit the values put into the calculator(in case of mistakes made when tapping your screen).


- **Currency Converter:**
    - Pretty simple to use also.
    - Fetches data from public API(exchangerate API)
    - Change your currency type. **(available tpyes are: USD, NGN, EUR, GBP, CAD and GHS)**
    - Instant currency conversion as you input your amount. 
    (was thinking of using a convert button but that'll be too stressful for the users. Idea was gotten when using google's default currency converter).