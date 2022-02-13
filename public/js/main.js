





//Information: click on the button with the meal, in the prompt box write down what interests you and the answer will appear in the next alert.
const gyros = {
    meat: 'pork',
    sideDish: 'pita bread',
    price: 350,
    preparation: '5min',
    allergens: ['gluten', 'milk', 'mustard']
};

const moussaka = {
    meat: 'beef',
    sideDish: 'potatoes',
    price:390,
    preparation: '15min',
    allergens: ['gluten', 'milk', 'eggs']
};

const chtapodi = {
    meat: 'octopus',
    sideDish: 'mixed salad',
    price:550,
    preparation: '10min',
    allergens: ['mollusc', 'gluten']
};

const burekakia = {
    meat: 'no meat',
    sideDish: 'no side dish',
    price:250,
    preparation: '15min',
    allergens: ['gluten', 'milk']
};

const flogeres = {
    meat: 'lamb',
    sideDish: 'fava',
    price:350,
    preparation: '15min',
    allergens: ['gluten', 'milk']
};

document.getElementById('gyros').addEventListener('click', function () {
    const information = prompt('What do you want to know about Gyros? Choose between meat, sideDish, price, preparation, allergens');

    if (gyros[information]) {
        alert(gyros[information]);
    } else {
        alert('Wrong request!')
    }
});


document.getElementById('moussaka').addEventListener('click', function () {

    const information = prompt('What do you want to know about Moussaka? Choose between meat, sideDish, price, preparation, allergens');

    if (moussaka[information]) {
        alert(moussaka[information]);
    } else {
        alert('Wrong request!')
    }
});

document.getElementById('chtapodi').addEventListener('click', function () {
    const information = prompt('What do you want to know about Chtapodi? Choose between meat, sideDish, price, preparation, allergens');

    if (chtapodi[information]) {
        alert(chtapodi[information]);
    } else {
        alert('Wrong request!')
    }
});

document.getElementById('burekakia').addEventListener('click', function () {
    const information = prompt('What do you want to know about Burekakia? Choose between meat, sideDish, price, preparation, allergens');

    if (burekakia[information]) {
        alert(burekakia[information]);
    } else {
        alert('Wrong request!')
    }
});


document.getElementById('flogeres').addEventListener('click', function () {
    const information = prompt('What do you want to know about Flogeres? Choose between meat, sideDish, price, preparation, allergens');

    if (flogeres[information]) {
        alert(flogeres[information]);
    } else {
        alert('Wrong request!')
    }
});

//Book a table: after the full filling of the table I will see in the console the result in this form
// INSERT INTO guest (firstName, lastName, email) VALUES ('Johny', 'Black', 'johnyblack@hotmail.com')

document.getElementById('send').addEventListener('click', function () {
    const first = document.getElementById('formGroupExampleInput').value;
    const last = document.getElementById('formGroupExampleInput2').value;
    const email = document.getElementById('exampleInputEmail1').value;
    const select = document.getElementById('floatingSelect').value


    //console.log([first, last, email, select])


    if (first === '' || last === '' || email === '' || select === '') {
        alert('Please fill all fields!')

    } else {
        console.log(`INSERT INTO guests (firstName, lastName, email)
                     VALUES (${first}, ${last}, ${email})`);


        const thankYou = document.getElementById('reservation');
        //console.log(thankYou);
        thankYou.classList.remove('visually-hidden');


        };


        document.getElementById('formGroupExampleInput').value = '';
        document.getElementById('formGroupExampleInput2').value = '';
        document.getElementById('exampleInputEmail1').value = '';
        document.getElementById('floatingSelect').value = 'selected';

});


//REVIEW WITH COOKIES

let reviews = document.querySelectorAll('[data-question]')


const resultTextToNumber = function (resultText) {
    if (resultText === 'no') {
        return -1;
    } else {
        return 1;
    }
}
//---------------------------------KONVERZE YES -> 1, NO-> -1
const resultNumberToText = function (resultNumber) {
    if (resultNumber === -1) {
        return 'no';
    } else {
        return 'yes';
    }
}
//----------------------------------------

const bonuses = function (countYes) {
    if(countYes === 5) {
        return 10
    } else if (countYes === 4) {
        return 5
    } else {
        return 0
    }
}

const selectActive = function (e, resultText, questionId) {
    e.target.classList.add('active');

    const resultTextOpposite = resultText === "no" ? "yes" : "no"


    const oppositeTarget = document.querySelector(`[data-question="${questionId}"][data-result="${resultTextOpposite}"]`)
    oppositeTarget.classList.remove('active')
}

const numberOfPositiveAnswers = function (score) {
    let ones = Object.values(score).filter(function (numMinusPlus) {
        return numMinusPlus === 1
    })
    return ones.length;
}

//------------------------------------------------------------
const saveScore = function (score) {
    const expiration = new Date();
    expiration.setHours( expiration.getHours() + 2)
    document.cookie = `score=${JSON.stringify(score)}; expires=${expiration.toUTCString()}; path=/`;
}

//source: https://stackoverflow.com/a/49224652
function getCookie(name) {
    let cookie = {};
    document.cookie.split(';').forEach(function(el) {
        let [k,v] = el.split('=');
        cookie[k.trim()] = v;
    })
    return cookie[name];
}

const intializedScore = function () {
    const scoreCookie = getCookie('score')
    if(scoreCookie === undefined) {
        return {};
    }
    return JSON.parse(scoreCookie)
}

const restoreScore = function (score) {
    const questionIds = Object.keys(score);
    questionIds.forEach(function (questionId){
        const resultText = resultNumberToText(score[questionId])
        const oppositeTarget = document.querySelector(`[data-question="${questionId}"][data-result="${resultText}"]`)
        oppositeTarget.classList.add('active')
    })

    //2. přeuložit jako nové score
    //3. označit ty tlačítka
    //4. udelat konverzi z 1 na yes a z -1 na no
    //5. najít tlačítka podle score
    // 6. označit nalezená tlačítka
}
// --------------------------------------------------


let score =  intializedScore();

//---------------------
restoreScore(score)
//---------------------

for(let i=0; i<reviews.length; i++) {
    reviews[i].addEventListener('click', function (e) {

        const questionId = e.target.getAttribute('data-question');
        const resultText = e.target.getAttribute('data-result');

        score[questionId] = resultTextToNumber(resultText);
        saveScore(score)

        // ---------------------------- 1.část



        selectActive(e, resultText, questionId)

        // -------------------------2.část
console.log(score)

        //
        const numberOfAnsweredQuestions = Object.keys(score).length;
        const maxNumberOfQuestions=reviews.length/2

        if (numberOfAnsweredQuestions === maxNumberOfQuestions){
            const reservationId = parseInt(prompt('Please insert your number of reservation'), 10);
                if (isNaN(reservationId)) {
                    alert('Not valid number');
                } else {
                    alert('Thank you for your opinion!');
                    console.log(bonuses(numberOfPositiveAnswers(score)) + '$');
                    score = {}
                }
        }
    });
}

