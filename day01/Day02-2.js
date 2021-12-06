const fs = require('fs');

const input = fs.readFileSync('input.txt', 'utf-8').split('\n').map(val => parseInt(val));

const count_increases = (nums) => 
    nums.reduce((acc, num, i) =>
        (i > 0 && get_window(nums, i) > get_window(nums, i-1))
        ? acc + 1
        : acc
    , 0);

const get_window = (nums, start) => nums.slice(start, start + 3).reduce((val, acc) => acc + val);
console.log(count_increases(input));