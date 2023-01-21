original_string = input("Enter a string: ")
index = int(input("Enter the index of the character you want to change: "))
new_char = input("Enter the new character: ")

original_string = list(original_string)
original_string[index] = new_char
modified_string = ''.join(original_string)

print("Modified string: ", modified_string)