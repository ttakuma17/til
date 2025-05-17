const isNumeric = (value) => {
    return typeof value === 'number' && !isNaN(value)
}

const validateArgs = (args) => {
    if (args.length > 30) {
        throw new Error('引数は30個までしか指定できません')
    }
    if (!args.every(isNumeric)) {
        throw new Error('引数は数値である必要があります')
    }
}

export const add = (...args) => {
    validateArgs(args)
    const sum = args.reduce((acc, curr) => acc + curr, 0)
    return sum > 1000 ? 'too big' : sum
}

export const subtract = (a, b) => {
    validateArgs([a, b])
    const result = a - b
    return result < 0 ? 'negative number' : result
}

export const multiply = (a, b) => {
    validateArgs([a, b])
    const result = a * b
    return result > 1000 ? 'big big number' : result
}

export const divide = (a, b) => {
    validateArgs([a, b])
    if (b === 0) {
        throw new Error('0で割ることはできません')
    }
    return Math.floor((a / b) * 10) / 10
}
