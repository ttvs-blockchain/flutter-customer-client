/*
 * passwordFormatRegex
 * Multiple lookahead assertions:
 * (?!.* ): no white spaces
 * (?=.*?[A-Z]): at least one uppercase English letter
 * (?=.*?[a-z]): at least one lowercase English letter
 * (?=.*?[0-9]): at least one digit
 * (?=.*?[#?!@$%^&*-]): at least one special character
 * .{8,32}: minimum eight in length, maximum 32 in length
 */
const passwordFormatRegex =
    r'^(?!.* )(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,32}$';
const nameFormatRegex = r'^[\p{Letter}\p{Number} ]+$';
const countryIDFormatRegex = r'^[a-zA-Z0-9_.-\[\]\(\)]*$';
