const fs = require('fs');

const input = fs.readFileSync('input.txt', 'utf-8').split('\n').map(val => parseInt(val));

const count_increases = (nums) => 
    nums.reduce((acc, num, i) =>
        (i > 0 && num > nums[i-1])
        ? acc + 1
        : acc
    , 0);

console.log(count_increases(input));