pub trait SpanTraitExt<T> {
    /// Searches for an element the span, returning its index.
    fn position<+PartialEq<T>>(self: Span<T>, item: @T) -> Option<usize>;
}

impl SpanImpl<T, +Clone<T>, +Drop<T>> of SpanTraitExt<T> {
    fn position<+PartialEq<T>>(mut self: Span<T>, item: @T) -> Option<usize> {
        let mut index = 0_usize;
        loop {
            match self.pop_front() {
                Option::Some(v) => {
                    if v == item {
                        break Option::Some(index);
                    }
                    index += 1;
                },
                Option::None => { break Option::None; },
            };
        }
    }
}
