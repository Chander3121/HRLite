document.addEventListener("turbo:load", () => {
  const picker = document.getElementById("month-picker")
  if (!picker) return

  const hiddenInput = document.getElementById("selected-month")
  const submitBtn = document.getElementById("submit-btn")

  picker.querySelectorAll(".month-btn").forEach((btn) => {
    btn.addEventListener("click", () => {
      // Clear previous selection
      picker.querySelectorAll(".month-btn").forEach((b) => {
        b.classList.remove("ring", "ring-indigo-500", "bg-indigo-50")
      })

      // Mark selected
      btn.classList.add("ring", "ring-indigo-500", "bg-indigo-50")

      hiddenInput.value = btn.dataset.month
      submitBtn.disabled = false
    })
  })
})
