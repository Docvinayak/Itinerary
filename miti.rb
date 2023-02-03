# /Users/thrillophilia/Desktop/ruby projects/MITIE-models/english
require 'mitie'
require "ruby/openai"

def api_key
  return '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'
end

def api(text)
  client = OpenAI::Client.new(access_token: api_key)
  prompt = "Extract place entity as python list in #{text}"

  response = client.completions(
      parameters: {
        model: "text-davinci-003",
        prompt: prompt,
        max_tokens: 2000
      })

  return response['choices'][0]['text']
end

def score_checker(entitie,openpassed)
  passed = []
  for word in entitie
    passed.append(word[:text]) if word[:tag] == 'LOCATION' or word[:text] in openpassed
  end
  puts passed
  passed
end

def model(text,openpassed)
  model = Mitie::NER.new('ner_model.dat')
  doc = model.doc(text)
  passed_words = score_checker(doc.entities,openpassed)
end

def day_split(text)
  text.split('Day')
end

def data_flow(text)
  broken_text = day_split(text)
	openpassed=api(text)
  for day_text in broken_text
		puts 'DAY---'
    model(day_text,openpassed)
  end
end

text = 'Heres a suggested 7-day itinerary for exploring Rajasthan:

Day 1: Arrive in Jaipur and visit Amber Fort, City Palace and Jantar Mantar.

Day 2: Explore Jaipur further, including Hawa Mahal, Jal Mahal and Birla Temple.

Day 3: Drive to Jodhpur and visit Mehrangarh Fort and Jaswant Thada Memorial.

Day 4: Drive to Udaipur and visit the City Palace and Jagdish Temple.

Day 5: Take a boat ride on Lake Pichola and visit Jagmandir Island Palace.

Day 6: Drive to Jaisalmer and explore the Golden Fort, Patwon Ki Haveli and Gadisar Lake.

Day 7: Drive back to Jaipur for your departure flight.'

data_flow(text)
