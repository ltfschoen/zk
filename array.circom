// https://zkrepl.dev/?gist=932b2189cd8502eb296b11e69ebe0c58

pragma circom 2.1.4;

// check if all array input elements have the same value. if so output value should be 1
// try changing the input from [0,0,0] to [0,0,1] and press SHIFT+ENTER to run and
// the assertion should fail since it detected the last element doesn't match

template Example (len) {
    // input signals: a1
    signal input a1[len]; // three elements
    signal output out;
    var a2[len] = a1;

    for(var i = 0; i < len; i++) {
        for(var j = 0; j < len; j++) {
            assert(a1[i] == a2[j]);
        }
    }

    out <== 1;
}

// instantiate the template
component main = Example(3);

// inputs. do not remove since this is not a comment
/* INPUT = {
    "a1": [0,0,0]
} */
