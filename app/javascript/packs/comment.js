document.addEventListener('turbolinks:load', function() {
  let newQuestionCommentElement = document.querySelector('.btn_new_question_comment')
  let Comments = document.querySelectorAll('a.delete_comment')

  let newAnswerCommentElements = document.querySelectorAll('.btn_new_answer_comment')


  newAnswerCommentElements.forEach(new_comment => { new_comment.addEventListener('click', newAnswerCommentForm) })
  if (newQuestionCommentElement) { newQuestionCommentElement.addEventListener('click', newQuestionCommentForm) }
  Comments.forEach(comment => { comment.addEventListener('click', deleteComment) })
})

function newQuestionCommentForm(e) {
  e.preventDefault()
  let questionId = this.dataset.questionId
  var editForm = document.querySelector('form#new_comment_question' + '_' + questionId)
  editForm.classList.remove('d-none')
  this.classList.add('d-none')
  editForm.querySelector('textarea').value = ""
}

function newAnswerCommentForm(e) {
  e.preventDefault()
  let answerId = this.dataset.answerId
  var editForm = document.querySelector('form#new_comment_answer' + '_' + answerId)
  editForm.classList.remove('d-none')
  this.classList.add('d-none')
  editForm.querySelector('textarea').value = ""
}

function deleteComment(e) {
  e.preventDefault()

  this.parentElement.remove()
}
