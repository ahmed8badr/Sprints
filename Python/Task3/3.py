def isBalanced(s):
    stack = []
    for bracket in s:
        if bracket in "([{":
            stack.append(bracket)
        elif bracket in ")]}":
            if not stack:
                return "NO"
            if bracket == ")" and stack[-1] != "(":
                return "NO"
            if bracket == "]" and stack[-1] != "[":
                return "NO"
            if bracket == "}" and stack[-1] != "{":
                return "NO"
            stack.pop()
    if stack:
        return "NO"
    return "YES"

n = int(input())
for i in range(n):
    s = input()
    print(isBalanced(s))
