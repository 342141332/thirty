package
{
    import flash.display.Sprite;
 
    public class FunSpeedBase extends Sprite
    {
        protected function overrideProtectedFunction(): void {}
        internal function overrideInternalFunction(): void {}
        public function overridePublicFunction(): void {}
 
        protected function finalOverrideProtectedFunction(): void {}
        internal function finalOverrideInternalFunction(): void {}
        public function finalOverridePublicFunction(): void {}
    }
}