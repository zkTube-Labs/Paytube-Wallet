package com.fictitious.money.purse.model;

import com.fictitious.money.purse.results.BaseModel;

import java.io.Serializable;
import java.math.BigDecimal;

public class GetVnsSeriesCurrencies extends BaseModel implements Serializable {

    /**
     * ticker : {"vol":250301.66,"last":6.11E-6,"sell":0,"buy":0,"high":6.16E-6,"low":5.74E-6}
     * date : 1568780207
     */

    private TickerBean ticker;
    private int date;

    public TickerBean getTicker() {
        return ticker;
    }

    public void setTicker(TickerBean ticker) {
        this.ticker = ticker;
    }

    public int getDate() {
        return date;
    }

    public void setDate(int date) {
        this.date = date;
    }

    public static class TickerBean implements Serializable{
        /**
         * vol : 250301.66
         * last : 6.11E-6
         * sell : 0
         * buy : 0
         * high : 6.16E-6
         * low : 5.74E-6
         */

        private BigDecimal vol;
        private BigDecimal last;
        private int sell;
        private int buy;
        private BigDecimal high;
        private BigDecimal low;

        public BigDecimal getVol() {
            return vol;
        }

        public void setVol(BigDecimal vol) {
            this.vol = vol;
        }

        public BigDecimal getLast() {
            return last;
        }

        public void setLast(BigDecimal last) {
            this.last = last;
        }

        public int getSell() {
            return sell;
        }

        public void setSell(int sell) {
            this.sell = sell;
        }

        public int getBuy() {
            return buy;
        }

        public void setBuy(int buy) {
            this.buy = buy;
        }

        public BigDecimal getHigh() {
            return high;
        }

        public void setHigh(BigDecimal high) {
            this.high = high;
        }

        public BigDecimal getLow() {
            return low;
        }

        public void setLow(BigDecimal low) {
            this.low = low;
        }
    }
}
