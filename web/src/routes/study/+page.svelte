<script lang="ts">
    import { cards } from '../../stores.js';
    let cardsData = [];
    let cardIndex = -1;
    let card = null;
    let isRevealed = false;

    cards.subscribe(value => {
        cardsData = value;
    });

    function reveal() {
        isRevealed = !isRevealed;
    }

    function previousCard() {
        if (cardIndex > 0) {
            cardIndex--;
            card = $cards[cardIndex];
            isRevealed = false;
        }
    }

    function nextCard() {
        if (cardIndex < cardsData.length) {
            cardIndex++;
        }
        if (cardIndex < cardsData.length) {
            card = $cards[cardIndex];
            isRevealed = false;
        }
    }
    function reset() {
        cardIndex = 0;
        card = $cards[cardIndex];
        isRevealed = false;
    }
</script>

{#if cardIndex < 0}
    <h2>Click next to begin</h2>
{:else if cardIndex >= cardsData.length}
    <h2>Finished studying!</h2>
{:else}
<div class="card" on:click={reveal} on:keypress={reveal}>
    <div class="card-front">
        <h1>{card.front}</h1>
    </div>
    {#if isRevealed}
    <div class="card-back">
        <h1>
            {card.back}
        </h1>
    </div>
    {/if}
</div>
{/if}
<div class='button-container'>
    <button on:click={previousCard}>Previous card</button>
    <button on:click={nextCard}>Next card</button>
    <button on:click={reset}>Start over</button>
</div>
<style>
    .card {
        background: rgba(0, 0, 0, 0.5);
        border: solid white 2px;
        border-radius: 6px;
        width: 450px;
        height: 150px;
        flex-grow: 1;
        flex-direction: column;
    }
    .card-front, .card-back {
        height:50%;
        text-align: center;
        vertical-align: middle;
        display: flex;
        flex-direction: column;
        justify-content: center;
    }

    .card-back {
        border-top: solid white 2px;
    }

</style>
