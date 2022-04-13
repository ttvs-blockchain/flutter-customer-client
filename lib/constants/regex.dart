/*
 * passwordFormatRegex
 * Multiple lookahead assertions:
 * (?!.* ): no white spaces
 * (?=.*?[A-Z]): at least one uppercase English letter
 * (?=.*?[a-z]): at least one lowercase English letter
 * (?=.*?[0-9]): at least one digit
 * (?=.*?[#?!@$%^&*-]): at least one special character
 * .{8,}: minimum eight in length
 */
const passwordFormatRegex =
    r'^(?!.* )(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$';
