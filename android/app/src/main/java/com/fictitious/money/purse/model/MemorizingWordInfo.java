package com.fictitious.money.purse.model;

import java.io.Serializable;

/**
 * Created by EDZ on 2018/7/23.
 */

public class MemorizingWordInfo implements Serializable {
    private int index;
    private String word;

    public int getIndex() {
        return index;
    }

    public void setIndex(int index) {
        this.index = index;
    }

    public String getWord() {
        return word;
    }

    public void setWord(String word) {
        this.word = word;
    }

    @Override
    public boolean equals(Object o) {
        if (o instanceof MemorizingWordInfo) {
            MemorizingWordInfo question = (MemorizingWordInfo) o;
            return this.index == (question.index)
                    && this.word.equals(question.word);
        }
        return super.equals(o);
    }
}
