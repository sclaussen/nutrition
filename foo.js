function deriveNameFromTitle(title) {
    let name = '';
    let firstCharFound = false;

    for (let i = 0; i < title.length; i++) {
        const ch = title[i];

        // If we haven't started conversion, skip everything until a-zA-Z
        if (!firstCharFound) {
            if (!/[a-zA-Z]/.test(ch)) {
                console.log('skip initial: ' + ch);
                continue;
            }
            firstCharFound = true;
        }

        // Skip everything but a-zA-Z0-9-
        if (!/[a-zA-Z0-9-]/.test(ch)) {
            continue;
        }

        // Consolidate consecutive dashes into a single -
        if (ch === '-' && name.charAt(name.length - 1) === '-') {
            continue;
        }

        name += ch;
    }

    // Remove trailing dashes post facto
    while (name.charAt(name.length - 1) === '-') {
        name = name.slice(0, -1);
    }

    return require('lodash').kebabCase(name);
}

// Example usage:
let titles = [
    // 'SomeWord%$# AndMore*!~',
    // ' My-Example--Title!123   ',
    '9-A0%--*#--BC12---',
];

for (let title of titles) {
    console.log();
    console.log(title);
    console.log(deriveNameFromTitle(title));
}
