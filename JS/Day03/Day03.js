const fs = require('fs');

const input = fs.readFileSync('input.txt', 'utf-8').split(/\r?\n/);

const day3 = (lines) => {
    const e = lines
        .map(line => Array
            .from(line)
            .map(digit => parseInt(digit)))
        .reduce((acc, val) =>
            acc.map((accVal, i) =>
                val[i] > 0
                ? accVal + 1
                : accVal - 1))
        .map(val => val > 0 ? 1 : 0)
    const g = e.map(val => val == 1 ? 0 : 1)
    return parseInt(e.join(''), 2) * parseInt(g.join(''), 2);
}

console.log(day3(input));