document.addEventListener('turbolinks:load', function() {
  let questionVote = document.querySelector('.question_vote')
  let answers = document.querySelectorAll('.answer')
  
  if (questionVote) { 
    questionVote.addEventListener('ajax:success', (questionSuccessVoteHandler))
    questionVote.addEventListener('ajax:error', (questionErrorVoteHandler))
  }
  answers.forEach(answer => {
    voteAnswer = answer.querySelector('.answer_vote')
    if (voteAnswer) { 
      voteAnswer.addEventListener('ajax:success', (answerSuccessVoteHandler))
      voteAnswer.addEventListener('ajax:error', (answerErrorVoteHandler))
    }
  });
})

function questionSuccessVoteHandler(e) {
  if (e.detail[1] == 'OK') {
    var newElement = prepareNewSuccessElement(e)
    var questionRatingElement = this.parentElement.querySelector('.question_rating')
    var questionRatingChild = questionRatingElement.childNodes[0]
    questionRatingElement.replaceChild(newElement, questionRatingChild)
  }
}

function questionErrorVoteHandler(e) {
  var newElement = prepareNewErrorElement(e)
  var questionErrorElement = this.parentElement.querySelector('.question-errors')
  if (questionErrorElement.hasChildNodes()) { 
    var oldElement = questionErrorElement.firstElementChild
    questionErrorElement.replaceChild(newElement, oldElement)
  } else {
    questionErrorElement.append(newElement)
  }
}

function answerSuccessVoteHandler(e){
  if (e.detail[1] == 'OK') {
    var newElement = prepareNewSuccessElement(e)
    var answerRatingElement = this.parentElement.querySelector('.answer_rating')
    var answerRatingChild = answerRatingElement.childNodes[0]
    answerRatingElement.replaceChild(newElement, answerRatingChild)
  }
}

function answerErrorVoteHandler(e) {
  var newElement = prepareNewErrorElement(e)
  var answerErrorElement = this.parentElement.querySelector('.answer-error')
  if (answerErrorElement.hasChildNodes()) { 
    var oldElement = answerErrorElement.firstElementChild
    answerErrorElement.replaceChild(newElement, oldElement)
  } else {
    answerErrorElement.append(newElement)
  }
}
  
function prepareNewSuccessElement(e) {
  var h5_elem = document.createElement("h5")
  var new_rating = document.createTextNode("Rating: "+ e.detail[0])
  h5_elem.append(new_rating)
  return h5_elem
}

function prepareNewErrorElement(e) {
  var h5_elem = document.createElement("li")
  var errorMessage =  e.detail[0].errorMessages[0]
  h5_elem.append(errorMessage)
  return h5_elem
}
