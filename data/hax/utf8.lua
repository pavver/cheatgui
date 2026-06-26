local UTF8_CHARACTER_PATTERN = "[%z\1-\127\194-\244][\128-\191]*"

local uppercase_to_lowercase = {}

local function add_case_mapping(uppercase, lowercase)
  local lowercase_characters = {}
  for character in lowercase:gmatch(UTF8_CHARACTER_PATTERN) do
    lowercase_characters[#lowercase_characters + 1] = character
  end

  local index = 1
  for character in uppercase:gmatch(UTF8_CHARACTER_PATTERN) do
    uppercase_to_lowercase[character] = lowercase_characters[index]
    index = index + 1
  end
end

add_case_mapping(
  "ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞŸ",
  "àáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ"
)
add_case_mapping(
  "ĄĆĘŁŃÓŚŹŻ",
  "ąćęłńóśźż"
)
add_case_mapping(
  "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯЄІЇҐ",
  "абвгдеёжзийклмнопрстуфхцчшщъыьэюяєіїґ"
)

function utf8_lower(value)
  return (value:gsub(UTF8_CHARACTER_PATTERN, function(character)
    return uppercase_to_lowercase[character] or character:lower()
  end))
end

function utf8_is_single_character(value)
  local character = value:match("^(" .. UTF8_CHARACTER_PATTERN .. ")$")
  return character == value
end

function utf8_remove_last_character(value)
  local byte_index = #value
  while byte_index > 0 do
    local byte = value:byte(byte_index)
    if byte < 128 or byte >= 192 then break end
    byte_index = byte_index - 1
  end
  return value:sub(1, byte_index - 1)
end
