module ChallengesHelper
  def category_emoji(category)
    case category
    when "fun"
      "😂"
    when "radio"
      "📻"
    when "computer"
      "🖥️"
    when "social"
      "🧑‍🤝‍🧑"
    when "homebrew"
      "🛠️"
    end
  end

  def difficulty_emoji(difficulty)
    case difficulty
    when "easy"
      "🟢"
    when "medium"
      "🟡"
    when "hard"
      "🔴"
    end
  end

  def status_emoji(status)
    case status
    when "completed"
      "✅"
    when "in_progress"
      "🚧"
    else
      "⌛"
    end
  end

  def status_label(status)
    case status
    when "completed"
      "Completed"
    when "in_progress"
      "In progress"
    else
      "Not started"
    end
  end
end
