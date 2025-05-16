import { describe, it, expect } from 'vitest'
import { add, subtract, multiply, divide } from './script'

describe('Calculator', () => {
    describe('足し算', () => {
        it('2つの数値の足し算ができること', () => {
            expect(add(1, 2)).toBe(3)
        })

        it('引数が30個までは足し算できること', () => {
            const args = Array(30).fill(1)
            expect(() => add(...args)).toBe(30)
        })

        it('引数が31個以上の場合は例外をはくこと', () => {
            const args = Array(31).fill(1)
            expect(() => add(...args)).toThrow()
        })

        it('数値以外の値で足し算しようとすると例外をはくこと', () => {
            expect(() => add(1, '2')).toThrow()
        })

        it('計算結果が1000を超えると too big を返すこと', () => {
            expect(add(500, 501)).toBe('too big')
        })
    })

    describe('引き算', () => {
        it('2つの数値で引き算ができること', () => {
            expect(subtract(5, 3)).toBe(2)
        })

        it('引き算の結果が負の数になった場合はnegative numer を返すこと', () => {
            expect(subtract(3, 5)).toBe('negative number')
        })

        it('数値以外の値で引き算しようとすると例外をはくこと', () => {
            expect(() => subtract(1, '2')).toThrow()
        })
    })

    describe('掛け算', () => {
        it('2つの数値の掛け算ができること', () => {
            expect(multiply(2, 3)).toBe(6)
        })

        it('計算結果が1000を超えると big big number を返すこと', () => {
            expect(multiply(50, 25)).toBe('big big number')
        })

        it('数値以外の値で掛け算しようとすると例外をはくこと', () => {
            expect(() => multiply(1, '2')).toThrow()
        })
    })

    describe('割り算', () => {
        it('2つの数値の割り算ができること', () => {
            expect(divide(6, 2)).toBe(3)
        })

        it('割り算の結果として小数点第一位を扱えること', () => {
            expect(divide(5, 2)).toBe(2.5)
        })

        it('割り算の結果として小数点第二位以下は切り捨てられること', () => {
            expect(divide(10, 3)).toBe(3.3)
        })

        it('数値以外の値で引き算しようとすると例外をはくこと', () => {
            expect(() => divide(1, '2')).toThrow()
        })

        it('0で割り算をすると例外をはくこと', () => {
            expect(() => divide(1, 0)).toThrow()
        })
    })
})

