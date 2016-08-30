class Supermemo
  def self.construct(review_seconds, efactor, repetition)
    quality = quality_calc(review_seconds)
    efactor_new = ef_calc(efactor, quality)
    repetition_new = repetition_calc(quality, repetition)
    days = interval_calc(repetition_new, efactor_new)
    { efactor: efactor_new,
      repetition: repetition_new,
      review_date: Date.today + days.ceil }
  end

  def self.quality_calc(review_seconds) # return quality
    case
    when (0..15).cover?(review_seconds.to_i) then 5
    when (16..30).cover?(review_seconds.to_i) then 4
    when (31..60).cover?(review_seconds.to_i) then 3
    else
      0
    end
  end

  def self.ef_calc(efactor, quality) # returns efactor_new
    efactor_new = efactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))
    efactor_new < 1.3 ? 1.3 : efactor_new
  end

  def self.repetition_calc(quality, repetition)
    quality >= 3 ? repetition += 1 : 0
  end

  def self.interval_calc(repetition_new, efactor_new) # returns days
    case
    when repetition_new == 0 then 0
    when repetition_new == 1 then 1
    when repetition_new == 2 then 6
    when repetition_new > 2 then (repetition_new - 1) * efactor_new
    end
  end
end
