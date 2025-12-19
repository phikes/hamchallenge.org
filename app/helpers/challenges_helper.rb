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
end
